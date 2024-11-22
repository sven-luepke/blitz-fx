#pragma once
#include <cstdint>
#include <unordered_map>

namespace w3
{

typedef uint64_t StringIdHash;

/*
 * Hashed strings
 */
class StringId
{
	friend class StringIdSentry;
public:
	StringId(const char* str);
	const char* c_str() const;
	StringIdHash GetHash() const;
private:
	constexpr StringId(uint64_t hash);

	StringIdHash hash;

	static constexpr StringIdHash ComputeHash(const char* str, size_t length);
	static std::unordered_map<uint64_t, const char*> string_id_map;

	friend constexpr StringIdHash operator"" _id(const char* str, size_t length);
	friend constexpr bool operator==(const StringId& sid1, const StringId& sid2);
	friend constexpr bool operator==(const StringId& sid, StringIdHash hash);
	friend constexpr bool operator==(StringIdHash hash, const StringId& sid);
	friend constexpr bool operator!=(const StringId& sid1, const StringId& sid2);
	friend constexpr bool operator!=(const StringId& sid, StringIdHash hash);
	friend constexpr bool operator!=(StringIdHash hash, const StringId& sid);
};


inline const char* StringId::c_str() const
{
	return string_id_map[hash];
}
inline uint64_t StringId::GetHash() const
{
	return hash;
}
constexpr StringId::StringId(uint64_t hash) : hash(hash)
{
}
constexpr uint64_t StringId::ComputeHash(const char* str, size_t length)
{
	// FNV-1a hash
	uint64_t hash = 14695981039346656037ULL;
	for (size_t i = 0; i < length; i++)
	{
		hash ^= static_cast<uint64_t>(str[i]);
		hash *= 1099511628211ULL;
	}
	return hash;
}
constexpr StringIdHash operator"" _id(const char* str, size_t length)
{
	return StringId::ComputeHash(str, length);
}
#define SID(string_literal) string_literal##_id
constexpr bool operator==(const StringId& sid1, const StringId& sid2)
{
	return sid1.hash == sid2.hash;
}
constexpr bool operator==(const StringId& sid, StringIdHash hash)
{
	return sid.hash == hash;
}
constexpr bool operator==(StringIdHash hash, const StringId& sid)
{
	return hash == sid.hash;
}
constexpr bool operator!=(const StringId& sid1, const StringId& sid2)
{
	return sid1.hash != sid2.hash;
}
constexpr bool operator!=(const StringId& sid, StringIdHash hash)
{
	return sid.hash != hash;
}
constexpr bool operator!=(StringIdHash hash, const StringId& sid)
{
	return hash != sid.hash;
}
}
