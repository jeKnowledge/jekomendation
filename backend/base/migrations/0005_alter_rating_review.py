# Generated by Django 4.1.3 on 2023-01-04 18:49

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0004_rating'),
    ]

    operations = [
        migrations.AlterField(
            model_name='rating',
            name='review',
            field=models.TextField(),
        ),
    ]
