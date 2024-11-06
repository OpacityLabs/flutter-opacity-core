package com.opacitylabs.flutter_opacity_core

data class OpacityResponse(
    val status: Int,
    val json: String?,
    val proof: String?,
    val err: String?
)
