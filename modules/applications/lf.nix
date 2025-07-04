{ lib, config, ... }:
{
  options = {
    applications.configuration.lf.enable = lib.mkEnableOption "Enables lf module";
  };

  config = lib.mkIf config.applications.configuration.lf.enable {
    # Home Manager as NixOS module
    home-manager.users.${config.settings.users.primary} =
      { config, ... }:
      {
        programs.lf = {
          enable = true;
          extraConfig = ''
            # Basic Settings
            set sortby time
            set reverse
            # set nopreview
            set hidden false
            set ignorecase true
            set drawbox
            # set icons true
            # set previewer ~/.config/lf/previewer.sh
            # set cleaner ~/.config/lf/clear_img.sh

            # Custom Functions
            cmd mkdir ''${{
                clear
                read -p "Directory Name: " ans
                mkdir "$ans"
            }}

            cmd mkfile ''${{
                clear
                read -p "File Name: " ans
                "$EDITOR" "$ans"
            }}

            cmd setwallpaper ''${{
                swww img "$f"
                mkdir -p ~/.config/wall
                cp "$f" ~/.config/wall/paper
            }}

            # Image view
            cmd viewimg ''${{
                pkill -SIGINT feh
                feh --scale-down --auto-zoom "$f" &
                sleep 0.4
                # xdotool key Alt+j
            }}

            cmd open ''${{
                case "$f" in 
                    *.jpg|*.jpeg|*.png|*.JPG) 
                        feh --scale-down --auto-zoom "$f" &
                        # pkill -SIGINT feh
                        # feh --scale-down --auto-zoom "$f" &
                        # sleep 0.4
                        # xdotool key Alt+k
                        ;;
                    *.pdf|*.PDF)  
                        zathura "$f" &
                        ;;
                    *.xopp|*.XOPP) 
                        xournalpp "$f" &
                        ;;

                    *.webm|*.mkv|*.mp4|*.WEBM|*.MKV|*.MP4)
                        mpv "$f"
                        ;;
                    *.ods|*.odp|*.odt|*.odg|*.odf|*.ODS|*.ODP|*.ODT|*.ODG|*.ODF)
                        libreoffice "$f" &
                        ;;
                    *.FCStd|*.FCSTD)
                        freecad "$f" &
                        ;;
                    *.rnote)
                        rnote "$f" &
                        ;;
                    *) 
                        if [ "$(stat -c %U "$f")" == "root" ]; then
                            clear
                            echo "Opening a file owned by root..."
                            sleep 0.5
                            # sudo -E -s $EDITOR "$f"
                            sudoedit "$f"

                        else
                            $EDITOR "$f"
                        fi
                        ;;
                esac
            }}

            # favorites
            cmd fave ''${{
                cp "$f" ~/Pictures/Wallpapers/Favorites
            }}

            cmd rm_fave ''${{
                rm ~/Pictures/Wallpapers/Favorites/"$f"
            }}


            # Archive bindings
            cmd unarchive ''${{
              case "$f" in
                  *.zip) unzip "$f" ;;
                  *.tar.gz) tar -xzvf "$f" ;;
                  *.tar.bz2) tar -xjvf "$f" ;;
                  *.tar) tar -xvf "$f" ;;
                  *) echo "Unsupported format" ;;
              esac
            }}

            cmd rename ''${{
                clear
                printf "Old Name: $f\n"
                read -p "New Name: " -e -i "$(basename "$f")" ans
                # Rename the file
                mv "$f" "$ans"
            }}


            cmd make ''${{
                make && sudo make install
            }}

            cmd scp_push ''${{
                clear

                if [[ "$1" == "c" ]]; then
                    echo "Copying to remote: $fx"
                elif [[ "$1" == "m" ]]; then
                    echo "Moving to remote: $fx"
                fi

                client="temp"
                until grep -w "$client" /home/$USER/.ssh/config; do

                    if [ ! "$client" == "temp" ]; then
                        echo "This client does not exist!"
                    fi

                    read -p "Client: " client
                done

                read -p "Directory: " -e -i "/home/$USER/" directory

                scp "$fx" "''${client}":"''${directory}"

                if [[ "$1" == "m" ]]; then
                    trash t "$fx"
                fi

            }}



            cmd remove ''${{
              IFS=$'\n'
              mapfile -t list <<< "$fx"
              for element in "''${list[@]}"; do 
                trash t "$element"
                echo "Trashed: $element"
              done
            }}

            cmd echo_f ''${{
              echo "$fx"
            }}

            cmd print_f ''${{
                while true; do
                    clear
                    echo "$fx"
                    read -p "Do you want to print this file? [y/n]: " ans
                    case $ans in
                        "y")
                            lp "$fx"
                            break
                            ;;
                        "n")
                            echo "Print not queued!"
                            break
                            ;;
                        *)
                            echo "Type 'y' or 'n'!"
                            ;;
                    esac
                done
            }}

            cmd show_pdf ''${{
              ~/.scripts/system_scripts/quick_pdf.sh "$f" &
            }}

            cmd delete ''${{
              while true; do 
                clear
                echo "$fx"
                read -p "You are about to permanently delete file(s)! Do you want to continue? [y/n]: " ans
                case "$ans" in 
                  "y")
                    IFS=$'\n'
                    mapfile -t list <<< "$fx"
                    for element in "''${list[@]}"; do 
                      if [ -d "$element" ]; then 
                        rm -r "$element"
                      else 
                        rm "$element"
                      fi
                      echo "Removed: $element"
                    done
                    break
                    ;;
                  "n")
                    break
                    ;;
                  *)
                    echo "Type 'y' or 'n'!"
                    ;;
                esac
              done
            }}

            cmd sudo_delete ''${{
              while true; do 
                clear
                echo "$fx"
                read -p "You are about to permanently delete file(s)! Do you want to continue? [y/n]: " ans
                case "$ans" in 
                  "y")
                    IFS=$'\n'
                    mapfile -t list <<< "$fx"
                    for element in "''${list[@]}"; do 
                      if [ -d "$element" ]; then 
                        sudo rm -r "$element"
                      else 
                        sudo rm "$element"
                      fi
                      echo "Removed: $element"
                    done
                    break
                    ;;
                  "n")
                    break
                    ;;
                  *)
                    echo "Type 'y' or 'n'!"
                    ;;
                esac
              done
            }}

            # remove defaults
            map m 
            map e
            map o
            map n
            map "'"
            map '"'
            map c clear
            map f
            map r

            # Basic Functions
            map . set hidden!
            map p paste
            map y copy
            map <enter> open
            map R reload

            map rr rename

            map rm delete
            map rsm sudo_delete
            map re remove

            map mf mkfile
            map md mkdir
            map mm make 

            map zz unarchive

            map bv viewimg
            map bg setwallpaper
            map bf fave
            map br rm_fave

            map gr   cd /
            map gh   cd ~/
            map gdw  cd ~/Downloads
            map gdo  cd ~/Dokumente
            map gno  cd ~/Notizen
            map gb   cd ~/Bilder
            map gV   cd ~/Videos
            map gt   cd ~/.Trash
            map gS   cd ~/.scripts
            map gC   cd ~/.config
            map gc   cd ~/Code
            map gva  cd /usr/local/share/valc
            map gvs  cd /usr/local/share/valc/source_code
            map gvc  cd /usr/local/share/valc/config_files
            map gvi  cd /usr/local/share/valc/install_scripts
            map guls cd /usr/local/share/
            map gusb cd /run/media
            map gmnt cd /mnt

            map xmv scp_push m
            map xcp scp_push c
            map xpr print_f
            map xpdf show_pdf
            map C clear
          '';

        };
      };
  };
}
