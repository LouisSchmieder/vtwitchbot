import vtwitchbot

fn main() {
    commandmap := {
        '!help': 'This is help'
    }

    mut twitchbot := twitchbot.TwitchBot{
        oauth: 'oauth:<token>'
        nick: '<botusername>'
        channel: ['<channelname>']
        commandmap: commandmap
    }
    twitchbot.connect()
}