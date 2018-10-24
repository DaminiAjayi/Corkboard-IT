from wtforms import Form, StringField, TextAreaField, PasswordField, validators,\
SelectField, RadioField

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
