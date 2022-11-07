# GITLAB CI NOTIFICATION

### available notification
- discord
- telegram

#### how to use
### Discord
forked from [GitLab CI 🡒 Discord Webhook](https://github.com/DiscordHooks/gitlab-ci-discord-webhook)

```yaml
    stages:
      - notification
    success_notification:
      stage: notification
      script:
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/discord.sh
        - chmod +x discord.sh
        - ./discord.sh success $WEBHOOK_URL
      when: on_success
    failure_notification:
      stage: notification
      script:
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/discord.sh
        - chmod +x discord.sh
        - ./discord.sh failure $WEBHOOK_URL
      when: on_failure
```

### Telegram
```yaml
stages:
    - notification
success_notification:
    stage: notification
    script:
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/telegram.sh
        - chmod +x telegram.sh
        - ./telegram.sh success $BOT_TOKEN $CHAT_ID
    when: on_success

failure_notification:
    stage: notification
    script:
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/telegram.sh
        - chmod +x telegram.sh
        - ./telegram.sh failure $BOT_TOKEN $CHAT_ID
    when: on_failure
```

### All Together
```yaml
stages:
    - notification
success_notification:
    stage: notification
    image: alpine/curl
    script:
        - 'apk --no-cache add wget curl'
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/telegram.sh
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/discord.sh
        - chmod +x telegram.sh
        - chmod +x discord.sh
        - sh ./telegram.sh success $BOT_TOKEN $CHAT_ID
        - sh ./discord.sh success $WEBHOOK_URL
    when: on_success

failure_notification:
    stage: notification
    image: alpine/curl
    script:
        - 'apk --no-cache add wget curl'
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/telegram.sh
        - wget https://raw.githubusercontent.com/athasamid/gitlab-ci-notification/master/discord.sh
        - chmod +x telegram.sh
        - chmod +x discord.sh
        - sh ./telegram.sh failure $BOT_TOKEN $CHAT_ID
        - sh ./discord.sh failure $WEBHOOK_URL
    when: on_failure
```

### Todo
- slack
- whatsapp