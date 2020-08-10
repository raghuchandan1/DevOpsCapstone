FROM nginx:mainline-alpine
RUN rm /etc/nginx/conf.d/*
COPY hello.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/
ADD https://get.aquasec.com/microscanner .
RUN chmod +x microscanner
RUN ./microscanner OWQ2YmQ1YWM4MTIw