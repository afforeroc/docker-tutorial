FROM python:3.9.0-slim-buster
RUN pip install flask
CMD ["python","app.py"]
COPY app.py /app.py