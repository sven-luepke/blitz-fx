#include "string_id.h"
#include <cassert>

namespace w3
{
std::unordered_map<uint64_t, const char*> StringId::string_id_map;

StringId::StringId(const char* str) : hash(ComputeHash(str, strlen(str)))
{
	auto it = string_id_map.find(hash);
	if (it == string_id_map.end())
	{
		string_id_map[hash] = _strdup(str);
	}
	else
	{
		assert(strcmp(str, it->second) == 0);
	}
}

/*
 * Is responsile for freeing all dynamically allocated string memory at the end of the program
 */
class StringIdSentry
{
public:
	~StringIdSentry()
	{
		for (auto& pair : StringId::string_id_map)
		{
			free(const_cast<char*>(pair.second));
		}
	}
};

static StringIdSentry sentry;
}
