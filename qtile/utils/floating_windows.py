from libqtile.log_utils import logger


def place_floating_window(qtile, h_position, v_position, windows_margin, windows_border_width):
    # Verify inputs
    assert h_position in ["left", "center", "right", "full"]
    assert v_position in ["top", "center", "bottom", "full"]
    logger.warning("\n\n")
    logger.warning("Placing window at " + str(h_position) + ", " + str(v_position))

    # Get the window to modify
    window = qtile.current_window
    if window:
        # Get the screen containing the window
        screen = None
        for sc in qtile.screens:
            # Check if window is on this screen
            if (sc.x <= window.x < sc.x + sc.width and
                sc.y <= window.y < sc.y + sc.height):
                screen = sc
                break

        # If we couldn't determine the screen, default to the current screen
        if not screen:
            screen = qtile.current_screen

        # Compute the available space using margin and screen size
        left_size = screen.left.size if screen.left else 0
        top_size = screen.top.size if screen.top else 0
        right_size = screen.right.size if screen.right else 0
        bottom_size = screen.bottom.size if screen.bottom else 0
        workarea_x = screen.x + left_size
        workarea_y = screen.y + top_size
        workarea_width = screen.width - left_size - right_size - windows_margin * 2
        workarea_height = screen.height - top_size - bottom_size - windows_margin * 2
        logger.warning("\ncomputed workarea: ")
        logger.warning(" > left_size: " + str(left_size))
        logger.warning(" > top_size: " + str(top_size))
        logger.warning(" > right_size: " + str(right_size))
        logger.warning(" > bottom_size: " + str(bottom_size))
        logger.warning(" > workarea_x: " + str(workarea_x))
        logger.warning(" > workarea_y: " + str(workarea_y))
        logger.warning(" > workarea_width: " + str(workarea_width))
        logger.warning(" > workarea_height: " + str(workarea_height) + "\n")

        position = [0, 0]
        dimention = [workarea_width, workarea_height]

        center_screen_ratio = 0.7

        # Compute horizontal position
        if h_position == "right":
            position[0] = int(0.5 * workarea_width + windows_margin / 2)
            logger.warning(" > Setting position[0] to " + str(position[0]))
        elif h_position == "center":
            position[0] = int((1 - center_screen_ratio) / 2 * workarea_width)
            logger.warning(" > Setting position[0] to " + str(position[0]))

        # Compute vertical position
        if v_position == "bottom":
            position[1] = int(0.5 * workarea_height + windows_margin / 2)
            logger.warning(" > Setting position[1] to " + str(position[1]))
        elif v_position == "center":
            position[1] = int((1 - center_screen_ratio) / 2 * workarea_height)
            logger.warning(" > Setting position[1] to " + str(position[1]))

        # Compute width
        if h_position == "left" or h_position == "right":
            dimention[0] = int(0.5 * workarea_width - windows_margin / 2)
            logger.warning(" > Setting dimention[0] to " + str(dimention[0]))
        elif h_position == "center":
            dimention[0] = int(center_screen_ratio * workarea_width)
            logger.warning(" > Setting dimention[0] to " + str(dimention[0]))
        elif h_position == "full":
            dimention[0] = int(workarea_width)
            logger.warning(" > Setting dimention[0] to " + str(dimention[0]))

        # Compute height
        if v_position == "top" or v_position == "bottom":
            dimention[1] = int(0.5 * workarea_height - windows_margin / 2)
            logger.warning(" > Setting dimention[1] to " + str(dimention[1]))
        elif v_position == "center":
            dimention[1] = int(center_screen_ratio * workarea_height)
            logger.warning(" > Setting dimention[1] to " + str(dimention[1]))
        elif v_position == "full":
            dimention[1] = int(workarea_height)
            logger.warning(" > Setting dimention[1] to " + str(dimention[1]))
        borders_width = 2 * windows_border_width
        dimention[0] -= borders_width
        dimention[1] -= borders_width
        logger.warning(" > computed position: " + str(position))
        logger.warning(" > computed dimention: " + str(dimention))

        window.toggle_floating()
        window.move_floating(*position)
        window.set_size_floating(*dimention)
