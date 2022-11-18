from rest_framework.response import Response
from rest_framework.decorators import api_view
from base.models import Suggestion, User
from .serializers import SuggestionSerializer

@api_view(['GET'])
def getSuggestions(request):
    sugestions = Suggestion.objects.all()
    serializer = SuggestionSerializer(sugestions, many = True)
    return Response(serializer.data)

@api_view(['POST'])
def postSuggestions(request):
    data = request.data
    
    suggestion = Suggestion.objects.create(
        user = data['user'],
        suggestion= data['suggestion'],
    )
    
    serializer = SuggestionSerializer(suggestion, many = False)
    if serializer.is_valid():
        serializer.save()
        
    return Response(serializer.data)