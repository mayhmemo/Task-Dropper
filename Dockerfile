FROM ghcr.io/cirruslabs/flutter:3.19.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake \
    ninja-build \
    clang \ 
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN flutter config --enable-web
RUN sdkmanager --install "platform-tools" "platforms;android-33"

WORKDIR /app

COPY . .

RUN flutter pub get

ENV PORT 5000

EXPOSE $PORT

CMD ["sh", "-c", "flutter run -d web-server --web-port=$PORT --web-hostname 0.0.0.0"]