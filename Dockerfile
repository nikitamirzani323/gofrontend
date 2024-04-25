FROM golang:alpine AS gobuild
WORKDIR /go/src/bitbucket.org/isbtotogroup/frontend_svelte
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app .

# ---- Svelte Base ----
FROM node:lts-alpine AS gobase
WORKDIR /svelteapp
COPY [ "frontend/package.json" , "frontend/yarn.lock"  , "./"]

# ---- Svelte Dependencies ----
FROM gobase AS gosveltedep
RUN yarn
RUN cp -R node_modules prod_node_modules

#
# ---- Svelte Builder ----
FROM gobase AS gosveltebuilder
COPY --from=gosveltedep /svelteapp/prod_node_modules ./node_modules
COPY ./frontend .
RUN yarn build

# Moving the binary to the 'final Image' to make it smaller
FROM alpine:latest as totosvelterelease
WORKDIR /app
COPY --from=gosveltebuilder /svelteapp/dist ./frontend/dist
COPY --from=gobuild /go/src/bitbucket.org/isbtotogroup/frontend_svelte/app .
COPY --from=gobuild /go/src/bitbucket.org/isbtotogroup/frontend_svelte/env-sample /app/.env
EXPOSE 2222
CMD ["./app"]