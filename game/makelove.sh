case $1 in
	-h)
		echo -e "makelove usage:\n\t-h : get help.\n\t-l <filename (no extension!)> : pack current directory in a .love file\n\t-e <filename (no extension!)> : pack current directory in a Windows Executable (.exe) and create a zip with the exe and all the required dlls."
	;;

	-l)
		if [ "$2" != "" ]; then
			echo "makelove -l: zipping folder to $2.love..."
			zip -r $2.love * -x\*~
			echo "makelove -l: done!"
		else
			echo "makelove -l: No file name specified!"
		fi
	;;

	-e)
		if [ "$2" != "" ]; then
			echo "makelove -e: zipping folder..."
			zip -r $2_tmp.love * -x\*~
			echo "makelove -e: appending data to love.exe..."
			cat ~/.makelove/love.exe $2_tmp.love > $2.exe
			echo "makelove -e: deleting tmp file..."
			rm $2_tmp.love
			echo "makelove -e: copying required dlls..."
			cp ~/.makelove/DevIL.dll ~/.makelove/OpenAL32.dll ~/.makelove/SDL.dll .
			echo "makelove -e: zipping everything..."
			zip $2.zip $2.exe DevIL.dll OpenAL32.dll SDL.dll
			echo "makelove -e: deleting tmp dlls..."
			rm $2.exe DevIL.dll OpenAL32.dll SDL.dll
			echo "makelove -e: done!"
		else
			echo "makelove -e: No file name specified!"
		fi
	;;

	*)
		echo "makelove: invalid parameter, type makelove -h for help."
	;;
esac
