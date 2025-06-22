import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/profile/profile_cubit.dart';
import '../cubit/profile/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../../domain/entities/profile.dart';

/// Edit Profile Page for updating user information
///
/// Features:
/// - Profile image upload/change
/// - Personal information editing
/// - Form validation and error handling
/// - Real-time save status
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  Profile? _originalProfile;
  String? _newImagePath;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    final profileCubit = context.read<ProfileCubit>();
    _originalProfile = profileCubit.currentProfile;

    if (_originalProfile != null) {
      _populateFields(_originalProfile!);
    } else {
      profileCubit.loadProfile();
    }
  }

  void _populateFields(Profile profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phoneNumber ?? '';
    _bioController.text = profile.bio ?? '';

    // Add listeners to detect changes
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _bioController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (_originalProfile == null) return;

    final hasChanges = _firstNameController.text != _originalProfile!.firstName ||
        _lastNameController.text != _originalProfile!.lastName ||
        _emailController.text != _originalProfile!.email ||
        _phoneController.text != (_originalProfile!.phoneNumber ?? '') ||
        _bioController.text != (_originalProfile!.bio ?? '') ||
        _newImagePath != null;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _handleBackPress(),
        ),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              )
                  : const Text('Save'),
            ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && _originalProfile == null) {
            setState(() {
              _originalProfile = state.profile;
            });
            _populateFields(state.profile);
          } else if (state is ProfileUpdated) {
            setState(() {
              _isLoading = false;
              _hasChanges = false;
              _originalProfile = state.profile;
              _newImagePath = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.tertiary,
              ),
            );
          } else if (state is ProfileError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          } else if (state is ProfileImageUploaded) {
            setState(() {
              _newImagePath = state.imageUrl;
              _hasChanges = true;
            });
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading && _originalProfile == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return _buildEditForm();
        },
      ),
    );
  }

  Widget _buildEditForm() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image Section
            _buildProfileImageSection(),

            const SizedBox(height: 32),

            // Personal Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Personal Information',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // First Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Enter your first name',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'First name must be at least 2 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Last Name
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        hintText: 'Enter your last name',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        if (value.trim().length < 2) {
                          return 'Last name must be at least 2 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (!RegExp(r'^[+]?[0-9\s\-()]{10,15}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bio Section Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About Me',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Bio
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        hintText: 'Tell us about yourself...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                      maxLength: 200,
                      validator: (value) {
                        if (value != null && value.length > 200) {
                          return 'Bio must be less than 200 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Account Info Card (Read-only)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Account Information',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _buildInfoRow(
                      'Username',
                      'roshdology123',
                      Icons.alternate_email,
                      theme,
                    ),

                    const SizedBox(height: 12),

                    _buildInfoRow(
                      'Member Since',
                      _originalProfile?.membershipDuration ?? 'Unknown',
                      Icons.calendar_today_outlined,
                      theme,
                    ),

                    const SizedBox(height: 12),

                    _buildInfoRow(
                      'Last Updated',
                      '2025-06-22 09:12:25',
                      Icons.update_outlined,
                      theme,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button (for mobile)
            if (_hasChanges)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Saving...'),
                    ],
                  )
                      : const Text('Save Changes'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    final theme = Theme.of(context);
    final imageUrl = _newImagePath ?? _originalProfile?.profileImageUrl;

    return Column(
      children: [
        Stack(
          children: [
            ProfileAvatar(
              imageUrl: imageUrl,
              initials: _originalProfile?.initials ?? 'AH',
              size: 120,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  onPressed: _showImageOptions,
                  icon: Icon(
                    Icons.camera_alt,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          'roshdology123',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),

        if (_newImagePath != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Chip(
              label: const Text('Image updated'),
              backgroundColor: theme.colorScheme.tertiary.withOpacity(0.2),
              labelStyle: TextStyle(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.w600,
              ),
              avatar: Icon(
                Icons.check_circle,
                size: 16,
                color: theme.colorScheme.tertiary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showImageOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Change Profile Photo',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  'Camera',
                  Icons.camera_alt_outlined,
                      () => _pickImage(ImageSource.camera),
                ),
                _buildImageOption(
                  'Gallery',
                  Icons.photo_library_outlined,
                      () => _pickImage(ImageSource.gallery),
                ),
                if (_originalProfile?.profileImageUrl != null || _newImagePath != null)
                  _buildImageOption(
                    'Remove',
                    Icons.delete_outline,
                    _removeImage,
                    color: theme.colorScheme.error,
                  ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(String label, IconData icon, VoidCallback onTap, {Color? color}) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: effectiveColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: effectiveColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        context.read<ProfileCubit>().uploadProfileImage(pickedFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _newImagePath = null;
      _hasChanges = true;
    });
    context.read<ProfileCubit>().deleteProfileImage();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_originalProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile data not loaded. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedProfile = _originalProfile!.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      profileImageUrl: _newImagePath,
      updatedAt: DateTime.parse('2025-06-22 09:12:25'),
    );

    context.read<ProfileCubit>().updateProfile(updatedProfile);
  }

  void _handleBackPress() {
    if (_hasChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }
}