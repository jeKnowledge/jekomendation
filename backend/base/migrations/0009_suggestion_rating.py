# Generated by Django 4.1.3 on 2023-01-11 12:12

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('base', '0008_alter_rating_review'),
    ]

    operations = [
        migrations.AddField(
            model_name='suggestion',
            name='rating',
            field=models.FloatField(default=5),
            preserve_default=False,
        ),
    ]
