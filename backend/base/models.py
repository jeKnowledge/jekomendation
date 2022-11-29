from django.db import models

class User(models.Model):
    username = models.CharField(max_length=150)   
    email = models.EmailField(default="email field", unique=True)
    created = models.DateTimeField(auto_now_add=True)
    is_staff = models.BooleanField(default=False)
    
    def __str__(self):
        return self.username
    

class Suggestion(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    suggestion = models.TextField()
    created =  models.DateTimeField(auto_now_add=True)
    

