from rest_framework import status
from google.oauth2 import id_token
from google.auth.transport import requests
from rest_framework.response import Response
from rest_framework import generics, permissions
from knox.models import AuthToken
from rest_framework.decorators import api_view
from base.models import Suggestion, User
from .serializers import SuggestionSerializer, RegisterSerializer, UserSerializer

@api_view(['GET'])
def getJekomandations(request):
    sugestions = Suggestion.objects.all()
    serializer = SuggestionSerializer(sugestions, many = True)
    
    for suggestion in serializer.data:
        user = User.objects.get(pk = suggestion['user'])
        user_serializer = UserSerializer(user, many = False)
        suggestion['user'] = user_serializer.data['username']
        
        
    print(serializer.data)
    return Response(serializer.data)


@api_view(['GET'])
def getJekomandation(request, pk):
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