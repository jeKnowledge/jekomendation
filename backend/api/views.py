from rest_framework.response import Response
from rest_framework import generics, permissions, status
from knox.models import AuthToken
from rest_framework.decorators import api_view
from base.models import Suggestion, User, Comment
from .serializers import SuggestionSerializer, RegisterSerializer, UserSerializer, CommentSerializer

@api_view(['GET'])
def getSuggestions(request):
    sugestions = Suggestion.objects.all()
    serializer = SuggestionSerializer(sugestions, many = True)
    return Response(serializer.data)


@api_view(['GET'])
def getSuggestion(request, pk):
    sugestions = Suggestion.objects.get(id=pk)
    serializer = SuggestionSerializer(sugestions, many = False)
    return Response(serializer.data)

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


@api_view(['GET', 'POST'])
def getComments(request, suggestionID):

    if request.method =='GET':
        comments = Comment.objects.filter(suggestion=suggestionID)
        serializer = CommentSerializer(comments, many = True)
        return Response(serializer.data)

    if request.method =='POST':
        serializer=CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)


