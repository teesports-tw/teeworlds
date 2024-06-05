FROM alpine:3.20 AS build

RUN apk update && apk add --no-cache \
	cmake \
	curl-dev \
	g++ \
	gcc \
	ninja \
	python3 \
	sqlite-dev \
	zlib-dev

COPY . /tw

WORKDIR /tw/build

RUN cmake .. \
	-Wnodev \
	-DCLIENT=OFF \
	-GNinja

RUN ninja

# ---

FROM alpine:3.20

RUN apk update && apk add --no-cache \
	libstdc++

COPY --from=build /tw/build/teeworlds_srv /tw/teeworlds_srv
COPY --from=build /tw/build/data /tw/data

WORKDIR /tw/data

ENTRYPOINT ["/tw/teeworlds_srv"]
