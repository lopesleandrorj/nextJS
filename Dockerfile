FROM node:lts as dependencies
WORKDIR /my-project
COPY package.json package-lock.json ./
RUN npm install


FROM node:lts as builder
WORKDIR /my-project
COPY ./ .
COPY --from=dependencies /my-project/node_modules ./node_modules
RUN yarn run build
FROM node:lts as runner
WORKDIR /my-project
ENV NODE_ENV production
COPY --from=builder /my-project/next.config.js ./
COPY --from=builder /my-project/node_modules ./node_modules
COPY --from=builder /my-project/package.json ./package.json

RUN chown -R 1004330000:0 "/.npm"
USER 1001
ENV HOSTNAME="0.0.0.0"
EXPOSE 3000

CMD ["npm", "start"]