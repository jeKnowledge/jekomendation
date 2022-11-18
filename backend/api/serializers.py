from rest_framework import serializers
from base.models import User, Suggestion

class SuggestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Suggestion
        fields: '__all__'