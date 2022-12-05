from django.urls import path
from . import views

urlpatterns = [
    path('jekomandations', views.getJekomandations ),
    path('jekomandation/<str:pk>/',views.getJekomandation),
    path('login/', views.login_google),
    path('register/', views.register, name='register'),
     #path('api/register/', user_views.RegisterAPI.as_view(), name='register'),
    #path('login/', auth_views.LoginView.as_view(frontend), name='login'),
    #path('logout/', auth_views.LogoutView.as_view(frontend), name='logout'), 
    path('jekomandation/', views.postJekomandation),
    
]
