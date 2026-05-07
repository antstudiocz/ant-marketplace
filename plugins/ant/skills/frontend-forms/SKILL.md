---
user-invocable: true
name: frontend-forms
description: Use when working with forms - covers react-hook-form with composed field components (label + input + error handling)
---

# Form Standards

## Architecture

This project uses **composed field components** that combine:

- Label
- Input/Select/Textarea
- Error display
- Validation integration with react-hook-form

**Common naming conventions:** `*Field`, `*Complete`, `*FormField`

> **Naming:** Always check what naming convention the project uses first. If the codebase uses `InputComplete`, use `InputComplete`. If it uses `InputField`, use `InputField`. Follow the existing pattern - only suggest renaming if explicitly asked.

## Stack

- **react-hook-form** - Form state management and validation
- **shadcn/ui** - Base input components (Input, Select, Textarea, Checkbox)
- **zod** (optional) - Schema validation

## Composed Field Components

| Component                            | Purpose                                         |
| ------------------------------------ | ----------------------------------------------- |
| `InputField` / `InputComplete`       | Text, email, password, number inputs with label |
| `SelectField` / `SelectComplete`     | Dropdown select with label                      |
| `TextareaField` / `TextareaComplete` | Multi-line text with label                      |
| `CheckboxField` / `CheckboxComplete` | Checkbox with label                             |

## Basic Usage

```tsx
import { useForm } from 'react-hook-form';
// Import your project's field components (naming may vary)
import { InputField } from '@/components/forms/InputField';
import { SelectField } from '@/components/forms/SelectField';

interface FormData {
  firstName: string;
  email: string;
  country: string;
}

function ContactForm() {
  const t = useTranslations('ContactForm');
  const form = useForm<FormData>({
    defaultValues: {
      firstName: '',
      email: '',
      country: '',
    },
  });

  const onSubmit = async (data: FormData) => {
    try {
      await submitData(data);
      toast.success(t('success'));
      form.reset();
    } catch {
      toast.error(t('error'));
    }
  };

  return (
    <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
      <InputField
        form={form}
        name="firstName"
        label={t('first-name')}
        required
      />

      <InputField
        form={form}
        name="email"
        label={t('email')}
        type="email"
        required
        rules={{
          pattern: {
            value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
            message: t('invalid-email'),
          },
        }}
      />

      <SelectField
        form={form}
        name="country"
        label={t('country')}
        options={countryOptions}
        required
      />

      <Button type="submit" disabled={form.formState.isSubmitting}>
        {form.formState.isSubmitting ? t('submitting') : t('submit')}
      </Button>
    </form>
  );
}
```

## Field Component Implementation

If your project doesn't have composed field components yet, here's how to create them:

```tsx
// components/forms/InputField.tsx
interface InputFieldProps {
  form: UseFormReturn<any>;
  name: string;
  label: string;
  required?: boolean;
  type?: string;
  placeholder?: string;
  rules?: RegisterOptions;
}

export function InputField({
  form,
  name,
  label,
  required,
  type = 'text',
  placeholder,
  rules,
}: InputFieldProps) {
  const t = useTranslations('validation');
  const {
    register,
    formState: { errors },
  } = form;
  const error = errors[name];

  return (
    <div className="space-y-2">
      <Label htmlFor={name}>
        {label}
        {required && <span className="text-destructive ml-1">*</span>}
      </Label>
      <Input
        id={name}
        type={type}
        placeholder={placeholder}
        {...register(name, { required: required && t('required'), ...rules })}
        aria-invalid={!!error}
        aria-describedby={error ? `${name}-error` : undefined}
      />
      {error && (
        <p
          id={`${name}-error`}
          className="text-sm text-destructive"
          role="alert"
        >
          {error.message as string}
        </p>
      )}
    </div>
  );
}
```

## Validation Rules

```tsx
// Required
<InputField form={form} name="name" label={t('name')} required />

// Email pattern
<InputField
  form={form}
  name="email"
  label={t('email')}
  required
  rules={{
    pattern: {
      value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
      message: t('invalid-email'),
    },
  }}
/>

// Min/max length
<InputField
  form={form}
  name="phone"
  label={t('phone')}
  rules={{
    minLength: { value: 9, message: t('too-short') },
    maxLength: { value: 15, message: t('too-long') },
  }}
/>
```

## With Zod Schema

```tsx
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(t('invalid-email')),
  password: z.string().min(8, t('password-too-short')),
});

type FormData = z.infer<typeof schema>;

const form = useForm<FormData>({
  resolver: zodResolver(schema),
});
```

## Loading States

```tsx
<fieldset disabled={form.formState.isSubmitting} className="space-y-4">
  <InputField ... />
  <InputField ... />
  <Button type="submit" disabled={form.formState.isSubmitting}>
    {form.formState.isSubmitting ? (
      <>
        <Loader className="mr-2 h-4 w-4 animate-spin" />
        {t('saving')}
      </>
    ) : (
      t('save')
    )}
  </Button>
</fieldset>
```

## When to Use Composed Fields vs Raw Components

| Use composed `*Field` / `*Complete` | Use raw `Input` / `Select` |
| ----------------------------------- | -------------------------- |
| In forms with validation            | Outside forms              |
| When you need label + error display | Custom/special layouts     |
| Standard form patterns              | One-off UI elements        |
