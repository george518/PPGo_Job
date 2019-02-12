FROM alpine:3.8

# Expose the application on port 8080*
EXPOSE 8080 443
RUN apk add tzdata bash --update-cache --repository http://mirrors.ustc.edu.cn/alpine/v3.8/main/ --allow-untrusted
RUN apk add --no-cache --virtual .build-deps curl tzdata --update-cache --repository http://mirrors.ustc.edu.cn/alpine/v3.8/main/ --allow-untrusted && \
    curl -o wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && chmod +x wait-for-it.sh && \
    apk del .build-deps
COPY conf/app.conf ./conf/
COPY static ./static
COPY views ./views
ADD PPGo_Job .
CMD ["./PPGo_Job"]
