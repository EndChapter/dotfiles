#!/usr/bin/bash
# Credits: https://gist.github.com/wandernauta/6800547

function get-metadata () {
	# Prints the currently playing track in a parseable format.
	dbus-send                                                                                 \
	--print-reply                                            `# We need the reply.`           \
	--dest=org.mpris.MediaPlayer2.spotify                    `# Spotify destination.`         \
	/org/mpris/MediaPlayer2                                  `# Spotify Path.`                \
	org.freedesktop.DBus.Properties.Get                      `# Get properties from dbus.`    \
	string:"org.mpris.MediaPlayer2.Player" string:'Metadata' `# Get metadata from properties.`\
	| grep -Ev "^method"                                     `# Ignore the first line.`       \
	| grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)'           `# Filter interesting fiels.`    \
	| sed -E '2~2 a|'                                        `# Mark odd fields.`             \
	| tr -d '\n'                                             `# Remove all newlines.`         \
	| sed -E 's/\|/\n/g'                                     `# Restore newlines.`            \
	| sed -E 's/(xesam:)|(mpris:)//'                         `# Remove ns prefixes.`          \
	| sed -E 's/^"//'                                        `# Strip leading...`             \
	| sed -E 's/"$//'                                        `# ...and trailing quotes.`      \
	| sed -E 's/"+/|/'                                       `# Regard "" as seperator.`      \
	| sed -E 's/ +/ /g'                                      `# Merge consecutive spaces.`    
}
function get-name () {
	get-metadata                                                                               \
	| grep "title"                                           `# Grep title from metadata`     \
	| cut -d "|" -f2-                                        `# Cut "title|" text from title` 
}
function get-artist () {
	get-metadata                                                                               \
	| grep "artist"                                           `# Grep Artist from metadata`   \
	| cut -d "|" -f2-                                        `# Cut "title|" text from title` 
}
echo $(get-artist) - $(get-name)
# sleep 5 # Sleep for 5 seconds for the sake of my cpu because it is in infinite loop
exit 1;

