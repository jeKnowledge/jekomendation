from django.urls import path
from . import views

urlpatterns = [
    path('', views.getSuggestions ),
    path('suggestion/<str:pk>/',views.getSuggestion),
    path('login/', views.login_google),
    
]
