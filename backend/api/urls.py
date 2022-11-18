from django.urls import path
from . import views

urlpatterns = [
    path('', views.getSuggestions ),
    path('create/', views.postSuggestions),
]
