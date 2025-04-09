local log_file = vim.fn.stdpath('data') .. '/nvim_log.txt'

local function write_log(message)
    local file = io.open(log_file, 'a') -- 'a' означает режим добавления
    if file then
        local timestamp = os.date('%Y-%m-%d %H:%M:%S')
        file:write(string.format('[%s] %s\n', timestamp, message))
        file:close()
    else
        vim.api.nvim_err_writeln('Ошибка: Не удалось открыть файл лога')
    end
end

return {
    write_log = write_log
}
