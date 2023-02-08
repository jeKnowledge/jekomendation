from django.db import models

class User(models.Model):
    username = models.CharField(max_length=150)   
    email = models.EmailField(default="email field", unique=True)
    created = models.DateTimeField(auto_now_add=True)
    is_staff = models.BooleanField(default=False)
    userReview = models.FloatField(default= "0") 
    
    def __str__(self):
        return self.username
    

class Suggestion(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    rating = models.FloatField()
    category = models.TextField()
    jekomandation = models.TextField()
    link = models.TextField()
    about = models.TextField()
    created =  models.DateTimeField(auto_now_add=True)
    
class Comment(models.Model):
    body=models.TextField()
    suggestion=models.ForeignKey(Suggestion, on_delete=models.CASCADE, related_name='comments')
    created=models.DateTimeField(auto_now_add=True)
    user=models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f'Comment form on {self.suggestion}'
    
class Rating(models.Model):
    user = models.ForeignKey(User,on_delete=models.CASCADE, related_name='StarReview')
    suggestion=models.ForeignKey(Suggestion, on_delete=models.CASCADE, related_name='ratings')
    review = models.FloatField()
    created=models.DateTimeField(auto_now_add=True)
