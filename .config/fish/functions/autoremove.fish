function autoremove
	sudo pacman -Rcns $(pacman -Qdtq)
end
