from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: list[str]) -> str:
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str], answer: str, target_window_id: int, boss: Boss
) -> None:
    tab = boss.active_tab
    if tab is not None:
        # Check if the current layout is the maximized one
        if tab.current_layout.name == "stack":
            # Restore to default layout
            tab.last_used_layout()
        else:
            pass
