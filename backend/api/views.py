from rest_framework import status
from google.oauth2 import id_token
from google.auth.transport import requests
from rest_framework.response import Response
from rest_framework import generics, permissions
from knox.models import AuthToken
from rest_framework.decorators import api_view
from base.models import Suggestion, User, Comment
from .serializers import SuggestionSerializer, RegisterSerializer, UserSerializer, CommentSerializer
from django.http import JsonResponse
import json
from rest_framework.generics import ListCreateAPIView, RetrieveUpdateDestroyAPIView
import jwt
import datetime
from .permissions import IsOwnerOrReadOnly

from backend.settings import SECRET_KEY

CLIENT_ID = "1028574994519-m4jie21dv7jjg5ae4skkd57qr60erkbh.apps.googleusercontent.com"

@api_view(['GET'])
def getJekomandations(request):
    sugestions = Suggestion.objects.all()
    serializer = SuggestionSerializer(sugestions, many = True)
    
    for suggestion in serializer.data:
        user = User.objects.get(pk = suggestion['user'])
        user_serializer = UserSerializer(user, many = False)
        suggestion['user'] = user_serializer.data['username']
        
        
    return Response(serializer.data)


@api_view(['GET'])
def getJekomandation(request, pk):
    suggestion = Suggestion.objects.get(id=pk)
    serializer = SuggestionSerializer(suggestion, many = False)
    
    serialized = serializer.data
    user = User.objects.get(pk = serializer.data['user'])
    user_serializer = UserSerializer(user, many = False)
    serialized['user'] = user_serializer.data['username']
    
    print(serialized)
    return Response(serialized)     
  
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
def postJekomandation(request):
     serializer = SuggestionSerializer(data = request.data)
     if(serializer.is_valid()):
         serializer.save()

     return Response(serializer.data);    


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
         print(idinfo)

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
         print(serializer.data)
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

    if request.method =='GET':
        comments = Comment.objects.filter(suggestion=suggestionID)
                
    if not comments:
        return Response([], status=status.HTTP_204_NO_CONTENT)
    else:                
        serializer = CommentSerializer(comments, many = True)
        
        for comment in serializer.data:
            user = User.objects.get(pk = comment['user'])
            user_serializer = UserSerializer(user, many = False)
            comment['user'] = user_serializer.data['username']

            print(serializer.data)
            return Response(serializer.data)

    if request.method =='POST':
        serializer=CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)