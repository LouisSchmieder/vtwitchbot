module vtwitchbot

import net

struct TwitchBot {
    oauth string
    nick string
    password string
    channel []string
    commandmap map[string]string
mut:
    socket net.Socket
    running bool
}

pub fn (bot mut TwitchBot) connect() {
    socket := net.dial('irc.chat.twitch.tv', 6667) or {
        println(err)
        return
    }

    println('Connected to Twitch server')

    bot.socket = socket
    bot.running = true

    bot.setup()
    bot.listen()
}

fn (bot mut TwitchBot) setup() {
    bot.sendircmessage('PASS', bot.oauth)
    bot.sendircmessage('NICK', bot.nick)
    bot.sendircmessage('USER', bot.nick)

    for channel in bot.channel {
        bot.sendircmessage('JOIN', '#$channel')
        println('Joined channel #$channel')
    }
}

fn (bot mut TwitchBot) listen() {
    START_LISTEN:
    bot.socket.listen()
    bot.handle(bot.socket.read_line())
    if bot.running {
        goto START_LISTEN
    }
}

fn (bot mut TwitchBot) handle(line string) {
    $if debug {
        println(line)
    }
    handleline := line.split(' ')

    if handleline[0] == 'PING' {
        bot.sendircmessage('PONG', ':tmi.twitch.tv')
    } else if handleline[1] == 'PRIVMSG' {
        username := handleline[0].split('!')[0].replace(':', '')
        channel := handleline[2]
        message := handleline[3].replace(':', '').trim_space().to_lower()
        $if debug {
            println('$channel $username -> $message')
        }
        if message.starts_with('!') {
            if message in bot.commandmap {
                bot.sendmessage(bot.commandmap[message], channel.replace('#', ''))
            } else {
                println('Unknown command')
            }
        }
        
    }
}

fn (bot mut TwitchBot) sendircmessage(prefix string, message string) {
    $if debug {
        println(prefix + ' ' + message + '\n\r')
    }
    bot.socket.write(prefix + ' ' + message + '\n\r')
}

pub fn (bot mut TwitchBot) sendmessage(message string, channel string) {
    bot.sendircmessage('PRIVMSG', '#$channel :$message')
}

pub fn (bot mut TwitchBot) close() {
    bot.running = false
    bot.socket.close()
}