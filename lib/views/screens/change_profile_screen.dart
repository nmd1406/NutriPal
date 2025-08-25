import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/auth_viewmodel.dart';
import 'package:nutripal/viewmodels/image_picker_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ChangeProfileScreen extends ConsumerStatefulWidget {
  const ChangeProfileScreen({super.key});

  @override
  ConsumerState<ChangeProfileScreen> createState() =>
      _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends ConsumerState<ChangeProfileScreen> {
  void _pickImage() {
    final imagePickerState = ref.read(imagePickerViewModelProvider);

    showDialog(
      context: context,
      barrierDismissible:
          !imagePickerState.isLoading, // Không cho đóng khi loading
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final imageState = ref.watch(imagePickerViewModelProvider);

          return AlertDialog(
            title: const Text("Chọn ảnh"),
            content: imageState.isLoading
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Đang tải ảnh lên..."),
                    ],
                  )
                : imageState.errorMessage != null
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        imageState.errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : null,
            actions: imageState.isLoading
                ? [] // Không hiển thị button khi loading
                : [
                    if (imageState.errorMessage != null) ...[
                      TextButton(
                        onPressed: () {
                          ref
                              .read(imagePickerViewModelProvider.notifier)
                              .clearError();
                        },
                        child: const Text("Thử lại"),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(imagePickerViewModelProvider.notifier)
                              .clearError();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Đóng"),
                      ),
                    ] else ...[
                      ListTile(
                        leading: const Icon(Icons.image),
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          await ref
                              .read(imagePickerViewModelProvider.notifier)
                              .pickImageFromGallery();
                          final state = ref.read(imagePickerViewModelProvider);
                          if (!state.isLoading &&
                              state.errorMessage == null &&
                              mounted) {
                            navigator.pop();
                          }
                        },
                        title: const Text("Thư viện"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera),
                        onTap: () async {
                          final navigator = Navigator.of(context);
                          await ref
                              .read(imagePickerViewModelProvider.notifier)
                              .pickImageFromCamera();
                          final state = ref.read(imagePickerViewModelProvider);
                          if (!state.isLoading &&
                              state.errorMessage == null &&
                              mounted) {
                            navigator.pop();
                          }
                        },
                        title: const Text("Camera"),
                      ),
                      if (imageState.selectedImage != null)
                        ListTile(
                          leading: const Icon(Icons.delete),
                          onTap: () {
                            ref
                                .read(imagePickerViewModelProvider.notifier)
                                .removeImage();
                            Navigator.of(context).pop();
                          },
                          title: const Text("Xoá"),
                        ),
                    ],
                  ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = ref.watch(imageUrlFromProfileProvider);
    final imageState = ref.watch(imagePickerViewModelProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: imageState.errorMessage != null
                  ? Colors.red
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: imageState.isLoading
                ? Container(
                    color: Colors.grey[100],
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : imageState.selectedImage != null
                ? Image.file(
                    imageState.selectedImage!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : avatarUrl.isNotEmpty
                ? Image.network(
                    avatarUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[100],
                        child: Icon(
                          Icons.error_outline,
                          size: 40,
                          color: Colors.red[300],
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey[100],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[600],
                    ),
                  ),
          ),
        ),

        // Camera button
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: imageState.isLoading ? Colors.grey : primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              onPressed: imageState.isLoading ? null : _pickImage,
              icon: Icon(
                imageState.isLoading ? Icons.hourglass_empty : Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),

        // Error indicator
        if (imageState.errorMessage != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error, color: Colors.white, size: 16),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final profileState = ref.watch(profileViewModelProvider);
    final authUserState = ref.watch(authViewModelProvider);
    final imageState = ref.watch(imagePickerViewModelProvider);

    final height = ref.watch(heightProvider);
    final gender = ref.watch(genderProvider);
    final age = ref.watch(ageProvider);
    final username = ref.watch(usernameFromProfileProvider);

    // Listen để hiển thị snackbar khi có lỗi
    ref.listen(imagePickerViewModelProvider, (previous, next) {
      if (next.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Đóng',
              onPressed: () {
                ref.read(imagePickerViewModelProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông tin cá nhân",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Skeletonizer(
          enabled: profileState.isLoading || authUserState.isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    _buildAvatar(),
                    if (imageState.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        imageState.errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              _buildProfileField(
                label: "Tên người dùng",
                value: username.isEmpty ? "Đang tải..." : username,
                icon: Icons.person_outline,
                onTap: () => _showUsernameDialog(),
              ),

              const SizedBox(height: 16),

              _buildProfileField(
                label: "Chiều cao",
                value: '${height.toInt()} cm',
                icon: Icons.height,
                onTap: () => _showHeightDialog(),
              ),

              const SizedBox(height: 16),

              _buildProfileField(
                label: "Giới tính",
                value: gender == "male" ? "Nam" : "Nữ",
                icon: Icons.wc,
                onTap: () => _showGenderDialog(),
              ),

              const SizedBox(height: 16),

              _buildProfileField(
                label: "Tuổi",
                value: "$age tuổi",
                icon: Icons.cake,
                onTap: () => _showAgeDialog(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  // Dialog để thay đổi tên người dùng
  void _showUsernameDialog() {
    final username = ref.read(usernameFromProfileProvider);
    final TextEditingController controller = TextEditingController(
      text: username,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thay đổi tên người dùng'),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Tên người dùng',
                  border: const OutlineInputBorder(),
                  errorText: errorText,
                ),
                maxLength: 50,
                onChanged: (value) {
                  setState(() {
                    errorText = ref
                        .read(profileViewModelProvider.notifier)
                        .validateUsername(value);
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed:
                      errorText == null && controller.text.trim().isNotEmpty
                      ? () async {
                          final scaffoldMessenger = ScaffoldMessenger.of(
                            context,
                          );
                          final navigator = Navigator.of(context);
                          try {
                            await ref
                                .read(profileViewModelProvider.notifier)
                                .updateProfileField(
                                  username: controller.text.trim(),
                                );
                            if (mounted) {
                              navigator.pop();
                            }
                          } catch (e) {
                            if (mounted) {
                              scaffoldMessenger.showSnackBar(
                                SnackBar(content: Text('Lỗi: $e')),
                              );
                            }
                          }
                        }
                      : null,
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showHeightDialog() {
    final height = ref.read(heightProvider);
    final TextEditingController controller = TextEditingController(
      text: height.toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thay đổi chiều cao'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Chiều cao (cm)',
                  border: const OutlineInputBorder(),
                  suffixText: 'cm',
                  errorText: errorText,
                ),
                onChanged: (value) {
                  setState(() {
                    errorText = ref
                        .read(profileViewModelProvider.notifier)
                        .validateHeight(value);
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed:
                      errorText == null && controller.text.trim().isNotEmpty
                      ? () {
                          ref
                              .read(profileViewModelProvider.notifier)
                              .updateHeight(controller.text);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showGenderDialog() {
    final currentGender = ref.read(genderProvider);
    String selectedGender = currentGender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Chọn giới tính'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Nam'),
                    value: 'male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Nữ'),
                    value: 'female',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(profileViewModelProvider.notifier)
                        .updateGender(selectedGender);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAgeDialog() {
    final age = ref.read(ageProvider);
    final TextEditingController controller = TextEditingController(
      text: age.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorText;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Thay đổi tuổi'),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tuổi',
                  border: const OutlineInputBorder(),
                  suffixText: 'tuổi',
                  errorText: errorText,
                ),
                onChanged: (value) {
                  setState(() {
                    errorText = ref
                        .read(profileViewModelProvider.notifier)
                        .validateAge(value);
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed:
                      errorText == null && controller.text.trim().isNotEmpty
                      ? () {
                          ref
                              .read(profileViewModelProvider.notifier)
                              .updateAge(controller.text);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
