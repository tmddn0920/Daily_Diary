String getEmotionFileName(int index) {
  const emotionMap = {
    0: "happy",
    1: "normal",
    2: "worry",
    3: "sad",
    4: "mad",
  };

  return emotionMap[index] ?? "happy";
}