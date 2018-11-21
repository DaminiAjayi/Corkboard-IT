from wtforms import Form, validators, StringField, TextAreaField, PasswordField,\
SelectField, RadioField, IntegerField, SubmitField


# Search Pushpin Form
class SearchPushpinForm(Form):
    # Fields
    search = StringField(
        'Search description, tags, and Corkboard category',
        [validators.Length(min=1, max=80)])

# Add Corkboard Form
class AddCorkboardForm(Form):
    title = StringField('Title', [validators.Length(min=1, max=80)])
    category = SelectField('Category', choices=[])
    vis_choices = [
        ('public', 'Public'),
        ('private', 'Private')
        ]
    visibility = RadioField('Visibility', choices=vis_choices)
    password = StringField('Password',
        validators=[validators.Optional(), validators.Length(min=1, max=80)])


# User Login Form
class UserLoginForm(Form):
    email = StringField('Email', [validators.Length(min=1, max=80)])
    pin = IntegerField('PIN')

# Private Corkboard Login Form
class PrivateLoginForm(Form):
    password = StringField('Password', [validators.Length(min=1, max=30)])

# Corkboard View Form
class ViewCorkboardForm(Form):
    Follow = SubmitField(label='Follow')
    AddPushPin = SubmitField(label='Add PushPin')
    Watch = SubmitField(label='Watch')
