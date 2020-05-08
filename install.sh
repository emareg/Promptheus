#!/usr/bin/env sh 


SOURCE_ENTRY_SH='source ~/.promptheus/rc.sh # Promptheus Theme'
SOURCE_ENTRY_FISH='source ~/.promptheus/rc.fish  # Promptheus Theme'
TMP_DIR="/tmp/pt_tmp_Promptheus"


if [ "$1" = "remove" ]; then

	echo "Do you want to completely remove Promptheus?"
	echo -n "(y|n)? > "read yn </dev/tty
	if [ "$yn" != "${yn#[Yy]}" ] ;then
		echo "Uninstalling Promptheus..."
		rm -r "$HOME/.promptheus"
		sed -i '/^source ~\/.promptheus\/rc.sh # Promptheus Theme$/d' ~/.bashrc
		sed -i '/^source ~\/.promptheus\/rc.sh # Promptheus Theme$/d' ~/.zshrc
		sed -i '/^source ~\/.promptheus\/rc.fish # Promptheus Theme$/d' ~/.config/fish/config.fish
	fi
	exit 0
fi


echo "Creating temporary directory: $TMP_DIR"
if [ -d "$TMP_DIR" ]; then
	echo "ERROR! Temporary Folder '$TMP_DIR' already exists. This should not happen."
	echo "Run 'rm -r $TMP_DIR'."
	exit 1
fi

mkdir "$TMP_DIR"
echo "cd to $TMP_DIR"
cd "$TMP_DIR"


echo "Downloading Promptheus master.zip"
if type wget >/dev/null 2>&1; then
	wget https://github.com/emareg/Promptheus/archive/master.zip
elif type curl >/dev/null 2>&1; then
	echo "curl"
else
	echo "Sorry, you need curl or wget installed first."
fi

unzip master.zip > /dev/null

echo "Copying files to "
cp -r "./Promptheus-master/.promptheus" "$HOME/"
cd


echo "Cleaning up..."
rm -r "$TMP_DIR"

echo "All done."
echo "To uninstall, simply remove folder '~/.promptheus'."
echo ""

echo "Should I add the following three entries to your rc files?" 
echo " > echo 'source ~/.promptheus/rc.sh' >> ~/.bashrc"
echo " > echo 'source ~/.promptheus/rc.sh' >> ~/.zshrc"
echo " > echo 'source ~/.promptheus/rc.fish' >> ~/.config/fish/config.fish" 
echo "This will apply Promptheus Theme on Shell Start."
echo -n "(y|n)? > "
read yn </dev/tty
if [ "$yn" != "${yn#[Yy]}" ]; then
	echo "$SOURCE_ENTRY_SH" >> ~/.bashrc
	echo "$SOURCE_ENTRY_SH" >> ~/.zshrc
	echo "$SOURCE_ENTRY_DISH" >> ~/.config/fish/config.fish
fi


echo -n "Do you want to try Promptheus temporary on bash now? (y|n) " 
read yn </dev/tty
if [ "$yn" != "${yn#[Yy]}" ]; then
    bash --init-file ~/.promptheus/rc.sh
fi
exit 0
