from django.urls import path
from . import views

urlpatterns = [
    path('jekomandations', views.getJekomandations ),
    path('jekomandation/<str:pk>/',views.getJekomandation),
    path('login/', views.login_google),
    path('jekomandation/', views.postJekomandation),
    path('comment/<str:suggestionID>/', views.getComments),
    path('ratings/<str:suggestionID>/', views.overalRating),

]
