## Dotfiles

### My Linux dotfiles.

Management is by the included `./dotz` shell script. Subcommands are `./dotz
status` and `./dotz update`.

Dotfiles are stored in `files/` and the destination is configured in `dotzrc`.
Internally `dotz` stores the list of managed files in an associate array. The
key is the file name in `files/`, the value is the location to copy the config
file to.

M4 is used for macros to allow per host configs and common settings to
abstracted out of the configs to a common location. Macros are defined in
`m4/variables`. The short hostname is passed as `M4_HOST`.

### Under The Hood

Generating a config is effectively a one liner:

`cat m4/variables files/{src} | m4 -P -DM4_HOST=$(hostname -s) > {dst}`

where `{src}` is the source file in `files/` and `{dst}` is the location to write the config.

To generate a diff between the generated config and what is currently live:

`cat m4/variables files/{src} | m4 -P -DM4_HOST=$(hostname -s) | diff {dst} -`

The `dotz` utility wraps all this in the above mentioned subcommands.
