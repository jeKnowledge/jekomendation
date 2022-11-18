from django.db import models

class User(models.Model):
    name = models.CharField(max_length=30)
    created = models.DateTimeField(auto_now_add=True)

class Suggestion(models.Model):
    user = models.ForeignKey("User", models.SET_NULL, null=True)
    suggestion = models.CharField(max_length=200)
    created =  models.DateTimeField(auto_now_add=True)
    

