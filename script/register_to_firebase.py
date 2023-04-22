import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials
import click

from scrape import get_question_list

# Application Default credentials are automatically created.
cred = credentials.Certificate("content/today-s-kanji-firebase-adminsdk-h6k6o-cf889a72ad.json")
app = firebase_admin.initialize_app(cred)
db = firestore.client()

def register_question_list(input_date, question_list):
    db.collection('daily_questions').document(input_date).set(
        {
            'questions': question_list
        },
    )

@click.command()
@click.option("--input_date")
def main(input_date):
    question_list = get_question_list(
        ''.join(input_date.split('/'))
    )
    register_question_list(input_date, question_list)

if __name__ == "__main__":
    main()