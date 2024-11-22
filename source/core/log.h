#pragma once
#include "external/aixlog.h"
#include "comdef.h"
#include <string>

#undef ERROR

namespace w3
{
#define CHECK_HR(hresult) hr = hresult; \
                        if (FAILED(hr)) { \
                        _com_error err(hr); \
                        LPCTSTR errMsg = err.ErrorMessage(); \
                        std::wstring w_string(errMsg); \
                        LOG(ERROR) << #hresult << " failed: " << std::string(w_string.begin(), w_string.end()); }
}