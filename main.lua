-- @param x lol
function Hi(x)
    print(x)

    local my_array = {
        5, 4, 3, 2, 1
    }

    for _, v in pairs(my_array) do
        print(_, v)
    end

    print("my_array[0] = ", my_array[0], "my_array[1] = ", my_array[1])

    local my_dict = {
        hello = "henlo",
        ["wow-l"] = "wew",
        [18] = 9
    }

    print(my_array, my_dict, my_dict.hello, my_dict["wow-l"])

    for k, v in pairs(vim.api.nvim_win_get_cursor(0)) do
        print(k, v)
    end

    vim.cmd("normal gg")
    vim.cmd("normal V")
    vim.cmd("normal G")
end

Hi()
