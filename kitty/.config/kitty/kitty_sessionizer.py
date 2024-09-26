import os
from kitty.boss import Boss
import subprocess


def main(args: list[str]) -> str:
    search_dir = os.path.expanduser("~/git")
    # Generate list of directories within the search directory
    directories = (
        subprocess.run(
            [
                "find",
                search_dir,
                "-maxdepth",
                "1",
                "-type",
                "d",
                "-not",
                "-path",
                f"{search_dir}/.git",
            ],
            capture_output=True,
            text=True,
        )
        .stdout.strip()
        .split("\n")
    )
    directories.extend(["~/dotfiles/", "~/dotfiles/nvim/.config/nvim"])

    fzf_path = "/opt/homebrew/bin/fzf"
    fzf_command = [fzf_path, "--height", "40%", "--border"]

    try:
        # Capture the output of fzf
        selected_directory = subprocess.check_output(
            fzf_command, input="\n".join(directories), text=True
        ).strip()
    except subprocess.CalledProcessError:
        # If fzf is canceled or fails, return an empty string
        return ""

    if not selected_directory:
        return "No selection made."

    print(selected_directory)
    # Return the selected item
    return selected_directory


def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    # Create a new tab with the selected directory as the working director
    if answer and boss:
        tab = boss.new_tab_with_wd(answer)
        tab.set_title(os.path.basename(answer))
