FROM python:3.12.9-alpine3.21
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip -r requirements.txt
COPY bookstracker.py app.py
EXPOSE 80
CMD [ "python" "./app.py" ]