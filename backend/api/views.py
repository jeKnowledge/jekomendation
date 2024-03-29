from rest_framework import status
from google.oauth2 import id_token
from google.auth.transport import requests
from rest_framework.response import Response
from rest_framework import generics, permissions
from knox.models import AuthToken
from rest_framework.decorators import api_view
from base.models import Suggestion, User, Comment, Rating
from .serializers import RatingSerializer, SuggestionSerializer, RegisterSerializer, UserSerializer, CommentSerializer
from django.http import JsonResponse
from django.db.models import Avg
import json
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
import jwt
import datetime
from .permissions import IsOwnerOrReadOnly

from backend.settings import SECRET_KEY
# IOS CLIENT
# CLIENT_ID = "1028574994519-m4jie21dv7jjg5ae4skkd57qr60erkbh.apps.googleusercontent.com"
CLIENT_ID = "1028574994519-f8k2qaopihsn3a982d9opkrq53t3f8oj.apps.googleusercontent.com"

@api_view(['GET', 'POST'])
def jeKmandations_list(request):
    """
    List all code jeKmandations, or create a new jeKmandations.
    """
    if request.method == 'GET':
        sugestions = Suggestion.objects.all()
        serializer = SuggestionSerializer(sugestions, many = True)
        
        for suggestion in serializer.data:
            user = User.objects.get(pk = suggestion['user'])
            user_serializer = UserSerializer(user, many = False)
            suggestion['user'] = user_serializer.data
            rating = Rating.objects.filter(suggestion = suggestion['id']).aggregate(Avg('review')) 
            if not rating["review__avg"]: 
                suggestion['rating'] = 0
            else:
                suggestion['rating'] = rating["review__avg"]
                
        return Response(serializer.data)

    if request.method == 'POST':
        serializer = SuggestionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# @api_view(['GET', 'PUT', 'DELETE'])
@api_view(['GET'])
def jekomandation_detail(request, pk):
    """
    Retrieve, update or delete a code snippet.
    """
    try:
        jekomandation = Suggestion.objects.get(pk=pk)
    except Suggestion.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    # Bizarro como chatGPT fez isso
    if request.method == 'GET':
        serializer = SuggestionSerializer(jekomandation)
        user = User.objects.get(pk = serializer.data['user'])
        user_serializer = UserSerializer(user, many = False)
        data = serializer.data.copy()
        data['user'] = user_serializer.data
            
        rating = Rating.objects.filter(suggestion = data['id']).aggregate(Avg('review')) 
        if not rating["review__avg"]: 
             data['rating'] = 0
        else:
             data['rating'] = rating["review__avg"]
            
        return Response(data)
  
  
@api_view(['POST'])
class RegisterAPI(generics.GenericAPIView):
    serializer_class = RegisterSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response({
        "user": UserSerializer(user, context=self.get_serializer_context()).data,
        "token": AuthToken.objects.create(user)[1]
        })
        
           
@api_view(['POST'])
def login_google(request):
     # log in with google verify the token 
     body = json.loads(request.body)
     # remove de b'' from the token
     token = str(body['token'])

     # body has the google's token and the user's email, first_name, last_name
     try:
         # Specify the CLIENT_ID of the app that accesses the backend:
         idinfo = id_token.verify_oauth2_token(token, requests.Request(), CLIENT_ID)

         # ID token is valid. Get the user's Google Account ID from the decoded token.
         userid = idinfo['email']

         # lowercase the email and trim it
         if userid is None:
             return JsonResponse({"message": "Invalid Google Token"}, status=status.HTTP_400_BAD_REQUEST)

         userid = userid.lower().strip()
         # check if user exists
         if User.objects.filter(email=userid).exists():
             google_user = User.objects.get(email=userid)
         else:
             google_user = User.objects.create(
             username = idinfo['name'],
             email = idinfo['email'],
             )

         google_user.save()
         serializer = UserSerializer(google_user)
         # create token for user to login
         token = jwt.encode({
         'id': serializer.data,
         'exp': datetime.datetime.utcnow() + datetime.timedelta(weeks=6000)
         }, SECRET_KEY, algorithm='HS256')
         return JsonResponse({"key": str(token), "user": serializer.data}, status=status.HTTP_200_OK)

     except ValueError as e:
         print(e)
         # Invalid token
         return JsonResponse({"message": "Invalid Google Token"}, status=status.HTTP_400_BAD_REQUEST)

class UserList(ListCreateAPIView):
     queryset = User.objects.all()
     serializer_class = UserSerializer


class UserDetail(RetrieveUpdateDestroyAPIView):
     permission_classes = [
         permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly]

     queryset = User.objects.all()
     serializer_class = UserSerializer
     

@api_view(['GET', 'POST'])
def getComments(request, suggestionID):
    
    if request.method == 'GET':
        comments = Comment.objects.filter(suggestion=suggestionID)
                
        if not comments:
            return Response([], status=status.HTTP_204_NO_CONTENT)
        else:                
            serializer = CommentSerializer(comments, many = True)
        
        for comment in serializer.data:
            user = User.objects.get(pk = comment['user'])
            user_serializer = UserSerializer(user, many = False)
            comment['user'] = user_serializer.data['username']
            
        return Response(serializer.data)
    
    
    if request.method == 'POST':
        serializer=CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
@api_view(['GET', 'POST'])
def overalPostRating(request, suggestionID):
    
    if request.method == 'GET':
        rating = Rating.objects.filter(suggestion = suggestionID).aggregate(Avg('review', default = 0))  
         
        if not rating:
            return Response([], status=status.HTTP_204_NO_CONTENT)
                       
            
        return Response(rating)
    
    if request.method == 'POST':
        body = json.loads(request.body)
        # check if user already review
        if Rating.objects.filter(suggestion = suggestionID).exists():
            rating = Rating.objects.get(suggestion = suggestionID)
            rating.review = body['review']
            rating.save()
            serializer = RatingSerializer(data = rating)
            if serializer.is_valid():
                return Response(serializer.data)
            
        else:
            rating = Rating.objects.create(
                user = User.objects.get(pk = body['user']),
                review =  body['review'],
                suggestion = Suggestion.objects.get(pk = body['suggestion'])
            )
                 
        serializer = RatingSerializer(data = rating)
        
        if serializer.is_valid():
            serializer.save()
        if not serializer.is_valid():
            print(serializer.errors)
            
        return Response(serializer.data)
         

@api_view(['GET'])
def suggestions(request,type):
    sugestions = Suggestion.objects.filter(type=type)
    serializer = SuggestionSerializer(sugestions, many = True)
    
    for suggestion in serializer.data:
        user = User.objects.get(pk = suggestion['user'])
        user_serializer = UserSerializer(user, many = False)
        suggestion['user'] = user_serializer.data['username']
    print(serializer.data)
    return Response(serializer.data)

@api_view(['GET'])
def getUserSuggestions(request, userID):
    userSuggestions = Suggestion.objects.filter(user = userID)
    if not userSuggestions:
        return Response([], status=status.HTTP_204_NO_CONTENT)
    else:
        serializer = SuggestionSerializer(userSuggestions, many = True )
        
        for suggestion in serializer.data:
            user = User.objects.get(pk = suggestion['user'])
            user_serializer = UserSerializer(user, many = False)
            suggestion['user'] = user_serializer.data['username']
            rating = Rating.objects.filter(suggestion = suggestion['id']).aggregate(Avg('review')) 
            
            if not rating["review__avg"]:
                suggestion['rating'] = 0
            else:
                suggestion['rating'] = rating["review__avg"]
            
        return Response(serializer.data)
     
@api_view(['GET'])
def getUserInfo(request, userID):
    user = User.objects.get(id = userID)
        
    user_suggestions = Suggestion.objects.filter(user = userID)
    suggestions_serializer = SuggestionSerializer(user_suggestions, many = True)
    
    finalReview = {'userReview': 0}
    countReview =  Suggestion.objects.filter(user = userID).exclude(rating = 0).count()
    for suggestion in suggestions_serializer.data:
        if suggestion:
            rating = Rating.objects.filter(suggestion = suggestion['id']).aggregate(Avg('review', default = (0)))
            if rating['review__avg']:
                finalReview['userReview'] += rating['review__avg']
    
    finalReview['userReview'] = finalReview['userReview'] / countReview
    
    user.userReview = finalReview['userReview']
    user_serializer = UserSerializer(user, many = False)

    return Response(user_serializer.data) 
