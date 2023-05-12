/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     envoy/type/v3/http.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#ifndef ENVOY_TYPE_V3_HTTP_PROTO_UPB_H_
#define ENVOY_TYPE_V3_HTTP_PROTO_UPB_H_

#include "upb/collections/array_internal.h"
#include "upb/collections/map_gencode_util.h"
#include "upb/message/accessors.h"
#include "upb/message/internal.h"
#include "upb/mini_table/enum_internal.h"
#include "upb/wire/decode.h"
#include "upb/wire/decode_fast.h"
#include "upb/wire/encode.h"

// Must be last. 
#include "upb/port/def.inc"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
  envoy_type_v3_HTTP1 = 0,
  envoy_type_v3_HTTP2 = 1,
  envoy_type_v3_HTTP3 = 2
} envoy_type_v3_CodecClientType;



extern const upb_MiniTableFile envoy_type_v3_http_proto_upb_file_layout;

#ifdef __cplusplus
}  /* extern "C" */
#endif

#include "upb/port/undef.inc"

#endif  /* ENVOY_TYPE_V3_HTTP_PROTO_UPB_H_ */