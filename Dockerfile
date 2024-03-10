FROM ghcr.io/cirruslabs/flutter:3.19.2

# Instala o CMake
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cmake \
    ninja-build \
    clang \ 
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala as ferramentas Android SDK
RUN sdkmanager --install "platform-tools" "platforms;android-33"

WORKDIR /app

COPY . .

RUN flutter pub get
RUN flutter build web --release

ENV PORT 5000

EXPOSE $PORT

CMD ["sh", "-c", "flutter run -d web-server --release --web-port=$PORT"]