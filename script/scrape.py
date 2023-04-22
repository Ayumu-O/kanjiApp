import requests
from bs4 import BeautifulSoup
import re
import click

def get_question_list(input_date):
    url = f'https://kyounokanji.com/kanji/display2.cgi?date={input_date}'
    res = requests.get(url)
    content_type_encoding = res.encoding if res.encoding != 'ISO-8859-1' else None
    soup = BeautifulSoup(
        res.content,
        'html.parser',
        from_encoding=content_type_encoding
    )

    question_list = []
    sentences = soup.find_all(class_="td-txt")
    answers = soup.find_all(class_="td-btns")
    for sentence, btn in zip(sentences, answers):
        question = sentence.select('b')[0]
        prefix = question.previous_sibling
        suffix = question.next_sibling
        btn_str = btn.select('input')[1].get('onclick')
        pattern = r"ShowDetail\('(\S+?)'\);"
        match = re.search(pattern, btn_str)
        answer = match.group(1)

        question_list.append(
            {
                'question': question.text,
                'prefix': prefix.text[:-1],
                'suffix': suffix.text[1:],
                'answer': answer
            }
        )
    print(question_list)
    return question_list

@click.command()
@click.option("--input_date")
def main(input_date):
    get_question_list(input_date)

if __name__ == "__main__":
    main()
