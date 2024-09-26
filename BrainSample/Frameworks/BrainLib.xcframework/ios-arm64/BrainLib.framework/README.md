# OmnifitBrain

A description of this package.

Framework 프로젝트를 생성합니다.

  이름 : BrainLib
  BrainLib 안에 swift 파일추가


 — 터미널에서 실행 —
 # Archive 하기
       PROJECT_NAME="BrainLib"
       BUILD_DIR="./build"

      xcodebuild archive -scheme "${PROJECT_NAME}" -archivePath "${BUILD_DIR}/iphoneos.xcarchive" -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES -verbose

 # XCFramework 생성
     BUILD_DIR="./build"
     xcodebuild -create-xcframework \
         -framework "${BUILD_DIR}/iphoneos.xcarchive/Products/Library/Frameworks/BrainLib.framework" \
         -output "${BUILD_DIR}/BrainLib.xcframework"

