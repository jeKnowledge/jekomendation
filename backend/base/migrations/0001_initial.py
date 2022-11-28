# Generated by Django 4.1.3 on 2022-11-28 05:20

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.CharField(max_length=150, primary_key=True, serialize=False, unique=True)),
                ('username', models.CharField(max_length=150)),
                ('email', models.EmailField(default='email field', max_length=254, unique=True)),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('is_staff', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='Suggestion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('suggestion', models.TextField()),
                ('created', models.DateTimeField(auto_now_add=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='base.user')),
            ],
        ),
    ]
