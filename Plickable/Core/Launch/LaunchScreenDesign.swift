<?xml version="1.0" encoding="UTF-8"?>
<document type="com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB" version="3.0" toolsVersion="23727" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" launchScreen="YES" useTraitCollections="YES" useSafeAreas="YES" colorMatched="YES" initialViewController="01J-lp-oVM">
    <device id="retina6_12" orientation="portrait" appearance="light"/>
    <dependencies>
        <deployment identifier="iOS"/>
        <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="23721"/>
        <capability name="Named colors" minToolsVersion="9.0"/>
        <capability name="Safe area layout guides" minToolsVersion="9.0"/>
        <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
    </dependencies>
    <scenes>
        <!--View Controller-->
        <scene sceneID="EHf-IW-A2E">
            <objects>
                <viewController id="01J-lp-oVM" sceneMemberID="viewController">
                    <view key="view" contentMode="scaleToFill" id="Ze5-6b-2t3">
                        <rect key="frame" x="0.0" y="0.0" width="393" height="852"/>
                        <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                        <subviews>
                            <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" image="logoTextWhite" translatesAutoresizingMaskIntoConstraints="NO" id="fWo-XU-Zl7">
                                <rect key="frame" x="32" y="248" width="189" height="100"/>
                                <constraints>
                                    <constraint firstAttribute="width" constant="189" id="Bn0-m0-5JI"/>
                                    <constraint firstAttribute="height" constant="100" id="uDZ-IX-kwI"/>
                                </constraints>
                            </imageView>
                            <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" image="wave" translatesAutoresizingMaskIntoConstraints="NO" id="HST-W6-Wv3">
                                <rect key="frame" x="32" y="552" width="361" height="112"/>
                            </imageView>
                            <imageView clipsSubviews="YES" userInteractionEnabled="NO" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" image="Voice-Powered" translatesAutoresizingMaskIntoConstraints="NO" id="Pok-wC-Zzd">
                                <rect key="frame" x="36.000000000000014" y="390" width="214.33333333333337" height="40"/>
                                <color key="tintColor" white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
                                <constraints>
                                    <constraint firstAttribute="height" constant="40" id="VrD-6Z-nHo"/>
                                </constraints>
                            </imageView>
                            <imageView clipsSubviews="YES" userInteractionEnabled="NO" alpha="0.80000000000000004" contentMode="scaleAspectFit" horizontalHuggingPriority="251" verticalHuggingPriority="251" image="EmotionalInsight" translatesAutoresizingMaskIntoConstraints="NO" id="IVd-KM-bAZ">
                                <rect key="frame" x="35.999999999999986" y="438" width="237.66666666666663" height="40"/>
                                <color key="tintColor" white="1" alpha="1" colorSpace="custom" customColorSpace="genericGamma22GrayColorSpace"/>
                                <constraints>
                                    <constraint firstAttribute="height" constant="40" id="h8i-FX-gnE"/>
                                </constraints>
                            </imageView>
                        </subviews>
                        <viewLayoutGuide key="safeArea" id="Bcu-3y-fUS"/>
                        <color key="backgroundColor" name="BackgroundPrimary"/>
                        <constraints>
                            <constraint firstItem="fWo-XU-Zl7" firstAttribute="top" secondItem="Bcu-3y-fUS" secondAttribute="top" constant="130" id="Brp-Qu-gUl"/>
                            <constraint firstItem="IVd-KM-bAZ" firstAttribute="top" secondItem="Pok-wC-Zzd" secondAttribute="bottom" constant="8" id="C0q-NS-9Rx"/>
                            <constraint firstItem="Pok-wC-Zzd" firstAttribute="top" secondItem="fWo-XU-Zl7" secondAttribute="bottom" constant="42" id="CzM-hv-J2e"/>
                            <constraint firstItem="HST-W6-Wv3" firstAttribute="leading" secondItem="Bcu-3y-fUS" secondAttribute="leading" constant="32" id="FbS-9t-JaJ"/>
                            <constraint firstItem="IVd-KM-bAZ" firstAttribute="leading" secondItem="Bcu-3y-fUS" secondAttribute="leading" constant="36" id="SzY-dL-vIw"/>
                            <constraint firstItem="fWo-XU-Zl7" firstAttribute="leading" secondItem="Bcu-3y-fUS" secondAttribute="leading" constant="32" id="V39-1a-y4L"/>
                            <constraint firstItem="HST-W6-Wv3" firstAttribute="trailing" secondItem="Bcu-3y-fUS" secondAttribute="trailing" id="XFf-Zz-Tun"/>
                            <constraint firstItem="Pok-wC-Zzd" firstAttribute="leading" secondItem="Bcu-3y-fUS" secondAttribute="leading" constant="36" id="kjD-SS-3rT"/>
                            <constraint firstItem="Bcu-3y-fUS" firstAttribute="bottom" secondItem="HST-W6-Wv3" secondAttribute="bottom" constant="120" id="x33-Wb-f1v"/>
                        </constraints>
                    </view>
                </viewController>
                <placeholder placeholderIdentifier="IBFirstResponder" id="iYj-Kq-Ea1" userLabel="First Responder" sceneMemberID="firstResponder"/>
            </objects>
            <point key="canvasLocation" x="52.671755725190835" y="374.64788732394368"/>
        </scene>
    </scenes>
    <resources>
        <image name="EmotionalInsight" width="237.66667175292969" height="27"/>
        <image name="Voice-Powered" width="214.33332824707031" height="22.333333969116211"/>
        <image name="logoTextWhite" width="2638" height="773"/>
        <image name="wave" width="526" height="112"/>
        <namedColor name="BackgroundPrimary">
            <color red="0.49803921568627452" green="0.0" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
        </namedColor>
    </resources>
</document>
