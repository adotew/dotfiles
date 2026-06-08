vec2 cursorCenter(vec4 cursor) {
  return vec2(cursor.x + cursor.z * 0.5, cursor.y - cursor.w * 0.5);
}

float distanceToSegment(vec2 p, vec2 a, vec2 b) {
  vec2 ab = b - a;
  float denom = max(dot(ab, ab), 0.0001);
  float t = clamp(dot(p - a, ab) / denom, 0.0, 1.0);
  return length(p - (a + ab * t));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = fragCoord.xy / iResolution.xy;
  vec4 base = texture(iChannel0, uv);

  float movedAt = iTime - iTimeCursorChange;
  vec2 currentCenter = cursorCenter(iCurrentCursor);
  vec2 previousCenter = cursorCenter(iPreviousCursor);
  float cursorSpan = max(max(iCurrentCursor.z, iCurrentCursor.w), 1.0);

  float activeMove = step(distance(currentCenter, previousCenter), 0.5);
  activeMove = 1.0 - activeMove;

  float moveFade = exp(-movedAt * 8.0) * activeMove;
  float lineWidth = max(cursorSpan * 0.42, 2.0);
  float trailDist = distanceToSegment(fragCoord.xy, previousCenter, currentCenter);
  float trailMask = exp(-trailDist / lineWidth) * moveFade * 0.92;

  float headDist = length(fragCoord.xy - currentCenter);
  float headGlow = exp(-headDist / max(cursorSpan * 0.7, 2.0)) * 0.28;

  vec3 trailColor = mix(iCursorColor, vec3(1.0), 0.12);
  vec3 color = base.rgb;
  color += trailColor * trailMask;
  color += trailColor * headGlow;

  fragColor = vec4(color, base.a);
}
