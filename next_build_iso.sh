#!/bin/bash
#set -e

echo
echo
tput setaf 2
echo "################################################################## "
echo "Phase 1 : "
echo "- Setting General parameters"
tput sgr0

	# setting of the general parameters
	stone_arc_iso_RequiredVersion="stone_arc 76-1"
	buildFolder=$HOME"/Desktop/stone_arc_build"
	outFolder=$HOME"/Desktop/stone_arc_out"
	stone_arcVersion=$(sudo pacman -Q stone_arc)

tput setaf 4
echo "################################################################## "
echo "Do you have the right stone_arc version? : "$stone_arcVersion
echo "What is the required stone_arc version?  : "$stone_arc_iso_RequiredVersion
echo "Build folder                           : "$buildFolder
echo "Out folder                             : "$outFolder
echo "################################################################## "
tput sgr0

			if [ "$stone_arcVersion" == "$stone_arc_iso_RequiredVersion" ]; then
				tput setaf 1
				echo "##################################################################"
				echo "stone_arc has the correct version. Continuing ..."
				echo "##################################################################"
				tput sgr0
			else
			tput setaf 1
			echo "###################################################################################################"
			echo "You need to install the correct version of stone_arc"
			echo "Use 'sudo downgrade stone_arc' to do that"
			echo "or update your system"
			echo "If a new stone_arc package comes in and you want to test if you can still build"
			echo "the iso then change the version in line 37."
			echo "###################################################################################################"
			tput sgr0
			fi

echo
echo "################################################################## "
tput setaf 2
echo "Phase 2 :"
echo "- Checking if stone_arc is installed"
echo "- Saving current stone_arc version to stone_arc.md"
echo "- Making mkstone_arc verbose"
tput sgr0
echo "################################################################## "
echo

	package="archiso"

	#----------------------------------------------------------------------------------

	#checking if application is already installed or else install with aur helpers
	if pacman -Qi $package &> /dev/null; then

			echo "stone_arc is already installed"

	else

		#checking which helper is installed
		if pacman -Qi yay &> /dev/null; then

			echo "################################################################"
			echo "######### Installing with yay"
			echo "################################################################"
			yay -S --noconfirm $package
		fi

		# Just checking if installation was successful
		if pacman -Qi $package &> /dev/null; then

			echo "################################################################"
			echo "#########  "$package" has been installed"
			echo "################################################################"

		else

			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			echo "!!!!!!!!!  "$package" has NOT been installed"
			echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			exit 1
		fi

	fi

	echo
	echo "Saving current stone_arc version to stone_arc.md"
	sudo sed -i "s/\(^stone_arc-version=\).*/\1$stone_arcVersion/" ../stone_arc.md
	echo
	echo "Making mkstone_arc verbose"
	sudo sed -i 's/quiet="y"/quiet="n"/g' /usr/bin/mkstone_arc

echo
echo "################################################################## "
tput setaf 2
echo "Phase 3 :"
echo "- Deleting the build folder if one exists"
echo "- Copying the stone_arc folder to build folder"
tput sgr0
echo "################################################################## "
echo

	echo "Deleting the build folder if one exists - takes some time"
	[ -d $buildFolder ] && sudo rm -rf $buildFolder
	echo
	echo "Copying the stone_arc folder to build work"
	echo
	mkdir $buildFolder
	cp -r ../stone_arc $buildFolder/stone_arc

# echo
# echo "################################################################## "
# tput setaf 2
# echo "Phase 6 :"
# echo "- Cleaning the cache from /var/cache/pacman/pkg/"
# tput sgr0
# echo "################################################################## "
# echo

	# echo "Cleaning the cache from /var/cache/pacman/pkg/"
	# yes | sudo pacman -Scc

echo
echo "################################################################## "
tput setaf 2
echo "Phase 7 :"
echo "- Building the iso - this can take a while - be patient"
tput sgr0
echo "################################################################## "
echo

	[ -d $outFolder ] || mkdir $outFolder
	cd $buildFolder/stone_arc/
	sudo mkstone_arc -v -w $buildFolder -o $outFolder $buildFolder/stone_arc/


 	echo "Moving pkglist.x86_64.txt"
 	echo "########################"
	rename=$(date +%Y-%m-%d)
 	cp $buildFolder/iso/arch/pkglist.x86_64.txt  $outFolder/archlinux-$rename-pkglist.txt


# echo
# echo "##################################################################"
# tput setaf 2
# echo "Phase 9 :"
# echo "- Making sure we start with a clean slate next time"
# tput sgr0
# echo "################################################################## "
# echo

	#echo "Deleting the build folder if one exists - takes some time"
	#[ -d $buildFolder ] && sudo rm -rf $buildFolder

echo
echo "##################################################################"
tput setaf 2
echo "DONE"
echo "- Check your out folder :"$outFolder
tput sgr0
echo "################################################################## "
echo